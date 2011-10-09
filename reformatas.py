#!/usr/bin/python

import sys
import codecs
import re
import shutil
import os


import_stmt = re.compile(r"(\s*)import\s+([A-Za-z$_][A-Za-z0-9$_.]*);")

def order_imports_like_fdt(a, b):
	if a.startswith("flash."):
		if b.startswith("flash."):
			return cmp(a, b)
		else:
			return 1
	elif b.startswith("flash."):
		return -1
	else:
		return cmp(a, b)

class OrganizeImports(object):
	def __init__(self, output):
		self.output = output
		self.import_group = None
		self.current_indent = None

	def flush_group(self):
		last_tld = None
		if self.import_group is not None and len(self.import_group) > 0:
			for i in sorted(self.import_group, order_imports_like_fdt):
				tld = i.split(".", 1)[0]
				if last_tld is not None and tld != last_tld:
					self.output.write("")
				last_tld = tld
				
				self.output.write("{0}import {1};".format(
						self.current_indent, i))
			self.output.write("")
			self.output.write("")

		self.import_group = None
		self.current_indent = None

	def write(self, line):
		import_match = import_stmt.match(line)
		if import_match is not None:
			line_indent = import_match.group(1)
			line_import = import_match.group(2)

			if line_indent != self.current_indent:
				self.flush_group()
			
			if self.import_group is None:
				self.import_group = set()
				self.current_indent = line_indent
			
			self.import_group.add(line_import)
		elif len(line) == 0:
			if self.current_indent is None:
				self.output.write("")
		else:
			self.flush_group()
			self.output.write(line)

	def close(self):
		self.flush_group()
		self.output.close()


package_stmt = re.compile(r"package(\s+[A-Za-z$_][A-Za-z0-9$_.]*)?\s*{?")
PO_PASS_THROUGH = 0
PO_EXPECT_PACKAGE = 1
PO_EXPECT_OBRACE = 2
PO_IN_PACKAGE = 3

class PackageOutdenter(object):
	def __init__(self, output):
		self.output = output
		self.state = PO_EXPECT_PACKAGE

	def write(self, line):
		suppress_line = False
		if len(line) == 0 or self.state == PO_PASS_THROUGH:
			pass

		elif self.state == PO_EXPECT_PACKAGE:
			package_match = package_stmt.match(line)
			if package_match is not None:
				if line.endswith("{"):
					self.state = PO_IN_PACKAGE
				else:
					self.state = PO_EXPECT_OBRACE
			else:
				self.state = PO_PASS_THROUGH

		elif self.state == PO_EXPECT_OBRACE:
			if line == "{":
				self.state = PO_IN_PACKAGE
			else:
				self.state = PO_PASS_THROUGH

		elif self.state == PO_IN_PACKAGE:
			if line.startswith("\t"):
				suppress_line = True
				self.output.write(line[1:])
			elif line.startswith("    "):
				suppress_line = True
				self.output.write(line[4:])
			else:
				self.state = PO_PASS_THROUGH
		
		if not suppress_line:
			self.output.write(line)

	def close(self):
		self.output.close()


doc_open = re.compile(r"(\s*)/\*\*$")
doc_line = re.compile(r"(\s*) \*(/?)(.*)")
DG_PASS_THROUGH = 0
DG_EXPECT_OPEN = 1
DG_IN_DOC_COMMENT = 2

class DocGobbler(object):
	def __init__(self, output):
		self.output = output
		self.state = DG_EXPECT_OPEN
		self.current_indent = None

		self.comment_opener = None
		self.comment_lines = None
		self.comment_content = False
		self.comment_closer = None

	def write_if_not_none(self, line):
		if line is not None:
			self.output.write(line)

	def flush_comment(self, unconditional):
		if (unconditional or self.comment_content):
			self.write_if_not_none(self.comment_opener)
			for line in self.comment_lines:
				self.write_if_not_none(line)
			self.write_if_not_none(self.comment_closer)

		self.current_indent = None
		self.comment_opener = None
		self.comment_lines = None
		self.comment_content = False
		self.comment_closer = None

	def emit_comment_line(self, trailer):
		return trailer.find("@author") == -1 and trailer != " ..."

	def write(self, line):
		if self.state == DG_EXPECT_OPEN:
			open_match = doc_open.match(line)
			if open_match is not None:
				self.current_indent = open_match.group(1)
				self.comment_opener = line
				self.comment_lines = list()
				self.state = DG_IN_DOC_COMMENT
			else:
				self.output.write(line)

		elif self.state == DG_IN_DOC_COMMENT:
			line_match = doc_line.match(line)
			if line_match is not None:
				line_indent = line_match.group(1)
				close_slash = line_match.group(2)
				trailer = line_match.group(3).rstrip()

				if line_indent != self.current_indent:
					self.flush_comment(True)
					self.output.write(line)
					self.state = DG_EXPECT_OPEN

				elif close_slash == "/":
					self.comment_closer = line
					self.flush_comment(False)
					self.state = DG_EXPECT_OPEN
				else:
					if self.emit_comment_line(trailer):
						self.comment_lines.append(line)
						self.comment_content = self.comment_content or len(trailer) > 0

		else:
			self.output.write(line)

	def close(self):
		if self.state == DG_IN_DOC_COMMENT:
			self.flush_comment(True)
		self.output.close()


decorator_order = {
	'public':    10,
	'protected': 20,
	'private':   30,
	'internal':  40,

	'override':  50,
	'final':     60,
	'native':    70,
	
	'static':    80,
}
member_decl = set(["const", "function", "var"])

class Redecorator(object):
	def __init__(self, output):
		self.output = output

	def write(self, line):
		tokens = filter(lambda t: len(t) > 0, re.split(r"(\s+)", line))

		if len(tokens) > 0:
			line_dec = list()
			if tokens[0].isspace():
				indent = tokens.pop(0)
			else:
				indent = ""

			while len(tokens) > 0:
				t = tokens.pop(0)
				if t.isspace():
					pass
				elif t in decorator_order:
					# bundle the keyword with its trailing whitespace to
					# preserve line length
					line_dec.append((t, tokens.pop(0)))
				elif t in member_decl:
					line_dec.sort(key=lambda m: decorator_order[m[0]])
					line = indent + \
					       ''.join(map(lambda m: m[0] + m[1], line_dec)) + \
						   t + ''.join(tokens)
					self.output.write(line)
					return
				else:
					break

		self.output.write(line)

	def close(self):
		self.output.close()


class NewLiner(object):
	def __init__(self, output):
		self.output = output

	def write(self, line):
		self.output.write(line + "\n")

	def close(self):
		self.output.close()


class TabExpander(object):
	def __init__(self, output):
		self.output = output

	def write(self, line):
		self.output.write(line.replace("\t", "    "))

	def close(self):
		self.output.close()


class Cleaner(object):
	def __init__(self, output):
		self.output = output

	def write(self, line):
		self.output.write(line.lstrip(u'\ufeff').rstrip())

	def close(self):
		self.output.close()


def reformat(in_stream, out_stream):
	filter_chain = NewLiner(out_stream)
	filter_chain = TabExpander(filter_chain)
	filter_chain = Redecorator(filter_chain)
	filter_chain = OrganizeImports(filter_chain)
	filter_chain = PackageOutdenter(filter_chain)
	filter_chain = DocGobbler(filter_chain)
	filter_chain = Cleaner(filter_chain)
	for line in in_stream:
		filter_chain.write(line)
	filter_chain.close()


def reformat_source(in_file, backup_suffix = None):
	delete_backup = False
	if backup_suffix is None:
		backup_suffix = ".bak"
		delete_backup = True
		
	backup_file = in_file + backup_suffix
	shutil.copy2(in_file, backup_file)
	in_stream = codecs.open(backup_file, 'r', 'utf_8')
	out_stream = codecs.open(in_file, 'w', 'utf_8')
	reformat(in_stream, out_stream)
	out_stream.close()
	in_stream.close()
	if delete_backup:
		os.remove(backup_file)


def main():
	if len(sys.argv) < 2:
		print("Usage: {0} file.as ...".format(sys.argv[0]))
		sys.exit(2)
	else:
		for in_file in sys.argv[1:]:
			reformat_source(in_file, "~")


if __name__ == '__main__':
	main()
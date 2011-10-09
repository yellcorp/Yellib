#!/usr/bin/python

import subprocess
import re

from reformatas import reformat_source


git_modified_in_index = re.compile("[MARC]  ")

def get_changed_in_index():
	git_process = subprocess.Popen(["git", "status", "--porcelain", "-z"], 
	                               stdout=subprocess.PIPE)
	modified = list()
	chunk = ""
	has_output = True
	while has_output:
		chunk += git_process.stdout.read(0x10000)
		if len(chunk) == 0:
			has_output = False

		lines = chunk.split("\0")
		chunk = lines.pop()
		for line in lines:
			if git_modified_in_index.match(line):
				modified.append(line[3:])

	git_process.wait()
	return modified


def main():
	for f in filter(lambda f: f.endswith(".as"), get_changed_in_index()):
		print f
		reformat_source(f, "~")


if __name__ == '__main__':
	main()

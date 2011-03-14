import re

getset = """
public function get ${pubname}():${proptype}  {  return ${privname};  }
public function set ${pubname}(new_${pubname}:${proptype}):void  {  setProp("${privname}", new_${pubname});  }"""

templateRE = re.compile("\\$\\{([a-z]+)\\}")

vars = """
_width:Number
_height:Number
_useFill:Boolean
_fillColor:uint
_fillAlpha:Number
_useLine:Boolean
_lineThickness:Number
_lineColor:uint
_lineAlpha:Number
_linePixelHinting:Boolean
_lineScaleMode:String
_lineCaps:String
_lineJoints:String
_lineMiterLimit:Number
"""

def formatTemplate(templateString, templateExtract, varMap) :

	replace = lambda m: varMap.get(m.group(1), m.group(0))
	
	return templateExtract.sub(replace, templateString)

def formatCode(code, privateName, varType) :
	templateVars = {
		'privname': privateName,
		'pubname': privateName[1:],
		'proptype': varType
	}
	return formatTemplate(code, templateRE, templateVars)
	

for line in vars.split("\n") :
	if len(line) > 0 :
		pair = line.split(":", 1)
		if len(pair) == 2 :
			print(formatCode(getset, pair[0], pair[1]))

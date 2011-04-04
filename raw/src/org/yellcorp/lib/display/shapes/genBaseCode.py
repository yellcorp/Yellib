getset = """
public function get {public_name}():{var_type}  {{  return {private_name};  }}
public function set {public_name}(new_{public_name}:{var_type}):void  {{  setProp("{private_name}", new_{public_name});  }}"""

vars = """
width:Number
height:Number
useFill:Boolean
fillColor:uint
fillAlpha:Number
useLine:Boolean
lineThickness:Number
lineColor:uint
lineAlpha:Number
linePixelHinting:Boolean
lineScaleMode:String
lineCaps:String
lineJoints:String
lineMiterLimit:Number
"""

def format_code(code, public_name, var_type) :
	template_vars = {
		'public_name': public_name,
		'private_name': "_" + public_name,
		'var_type': var_type
	}
	return code.format(**template_vars)
	

for line in vars.split("\n") :
	if len(line) > 0 :
		pair = line.split(":", 1)
		if len(pair) == 2 :
			print(format_code(getset, pair[0], pair[1]))

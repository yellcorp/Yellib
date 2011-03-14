package org.yellcorp.tools
{
import org.yellcorp.lib.core.StringUtil;

import flash.filters.BitmapFilter;
import flash.filters.BitmapFilterType;
import flash.filters.DisplacementMapFilterMode;
import flash.geom.Point;
import flash.utils.describeType;
import flash.utils.getQualifiedClassName;


/**
 * This utility class captures the state of a filter or filters as authored
 * in the Flash IDE, and generates AS3 code to reconstruct them.  Intended
 * as a development aid and not a runtime library.
 */
public class FilterCapture
{
    private static var $filterMetadata:Object;
    private static const bareClassNameRegex:RegExp = /::([A-Za-z0-9_$]+)$/ ;

    /**
     * Returns AS3 code that constructs the specified array of filters in
     * their current state.  The Array syntax returned is inline; i.e.
     * [ new X(), new Y(), new Z() ];
     */
    public static function dumpFilterArray(filterArray:Array):String
    {
        var lines:Array = [ ];
        var i:int;

        for (i = 0; i < filterArray.length; i++)
        {
            lines.push( (i == 0 ? "" : "  ") + dumpFilter(filterArray[i]));
        }
        return "[ " + lines.join(",\n") + " ];";
    }

    /**
     * Returns AS3 code that constructs the specified filter in its
     * current state.  Trailing parameters are omitted if they match the
     * constructor's default.
     */
    public static function dumpFilter(filter:BitmapFilter):String
    {
        var i:int;
        var fqName:String = getQualifiedClassName(filter);
        var bareName:String = getBareClassName(fqName);
        var constructorParams:Array = getFilterMetadata()[fqName];
        var formattedValue:String;
        var defaultParams:Array = [ ];
        var params:Array = [ ];

        for (i = 0; i < constructorParams.length; i++)
        {
            formattedValue = formatValue(filter, constructorParams[i]);
            if (paramIsDefault(filter, constructorParams[i]))
            {
                defaultParams.push(formattedValue);
            }
            else
            {
                params = params.concat(defaultParams);
                defaultParams = [ ];
                params.push(formattedValue);
            }
        }

        return "new " + (bareName || fqName) + "(" +
               params.join(", ") + ")";
    }

    private static function paramIsDefault(filter:Object, param:Array):Boolean
    {
        return filter[param[0]] == param[1];
    }

    private static function formatValue(filter:Object, param:Array):String
    {
        var paramValue:*;
        var paramName:String = String(param[0]);
        var formatFunc:* = param[2] || null;

        paramValue = filter[paramName];

        if (formatFunc)
        {
            if (formatFunc is Class)
            {
                return formatConstant(paramValue, formatFunc);
            }
            else if (formatFunc is Function)
            {
                return formatFunc(paramValue);
            }
        }
        else
        {
            if (paramValue is String)
            {
                return formatStringLiteral(paramValue);
            }
            else if (paramValue.toString)
            {
                return paramValue.toString();
            }
            else
            {
                return String(paramValue);
            }
        }
        return null;
    }

    private static function formatConstant(value:*, constClass:*):String
    {
        var type:XML = describeType(constClass);
        var typeNameMatch:Object;
        var constant:XML;

        if (type.@base == "Class")
        {
            for each (constant in type.constant)
            {
                if (constClass[constant.@name] == value)
                {
                    typeNameMatch = getBareClassName(type.@name);
                    if (typeNameMatch)
                    {
                        return typeNameMatch + "." + constant.@name;
                    }
                }
            }
        }
        else
        {
            trace("constClass not a Class object");
        }
        return formatStringLiteral(value);
    }

    private static function getBareClassName(fqName:String):String
    {
        var match:Object = bareClassNameRegex.exec(fqName);
        return (match && match[1]) ? match[1] : null;
    }

    private static function formatStringLiteral(value:String):String
    {
        value = value.replace( '\\', '\\\\' );
        value = value.replace( '"', '\\"' );
        return '"' + value + '"';
    }

    private static function getFilterMetadata():Object
    {
        var m:Object;

        if (!$filterMetadata)
        {
            m = $filterMetadata = { };

            m["flash.filters::BevelFilter"] =
            [
                [ "distance",       4.0       ],
                [ "angle",          45        ],
                [ "highlightColor", 0xFFFFFF, formatHexColor ],
                [ "highlightAlpha", 1.0       ],
                [ "shadowColor",    0,        formatHexColor ],
                [ "shadowAlpha",    1.0       ],
                [ "blurX",          4.0       ],
                [ "blurY",          4.0       ],
                [ "strength",       1.0       ],
                [ "quality",        1         ],
                [ "type",           BitmapFilterType.INNER, BitmapFilterType ],
                [ "knockout",       false     ]
            ];
            m["flash.filters::BlurFilter"] =
            [
                [ "blurX",          4.0 ],
                [ "blurY",          4.0 ],
                [ "quality",        1   ]
            ];
            m["flash.filters::ColorMatrixFilter"] =
            [
                [ "matrix",         null, formatArray ],
            ];
            m["flash.filters::ConvolutionFilter"] =
            [
                [ "matrixX",       0     ],
                [ "matrixY",       0     ],
                [ "matrix",        null, formatArray ],
                [ "divisor",       1     ],
                [ "bias",          0     ],
                [ "preserveAlpha", true  ],
                [ "clamp",         true  ],
                [ "color",         0,    formatHexColor ],
                [ "alpha",         1.0   ],
            ];
            m["flash.filters::DisplacementMapFilter"] =
            [
                [ "mapBitmap",      null  ],
                [ "mapPoint",       null, formatPoint ],
                [ "componentX",     0     ],
                [ "componentY",     0     ],
                [ "scaleX",         0.0   ],
                [ "scaleY",         0.0   ],
                [ "mode",           DisplacementMapFilterMode.WRAP, DisplacementMapFilterMode ],
                [ "color",          0,    formatHexColor ],
                [ "alpha",          1.0   ],
            ];
            m["flash.filters::DropShadowFilter"] =
            [
                [ "distance",   4.0   ],
                [ "angle",      45    ],
                [ "color",      0,    formatHexColor ],
                [ "alpha",      1.0   ],
                [ "blurX",      4.0   ],
                [ "blurY",      4.0   ],
                [ "strength",   1.0   ],
                [ "quality",    1     ],
                [ "inner",      false ],
                [ "knockout",   false ],
                [ "hideObject", false ]
            ];
            m["flash.filters::GlowFilter"] =
            [
                [ "color",      0xFF0000, formatHexColor ],
                [ "alpha",      1.0       ],
                [ "blurX",      6.0       ],
                [ "blurY",      6.0       ],
                [ "strength",   2.0       ],
                [ "quality",    1         ],
                [ "inner",      false     ],
                [ "knockout",   false     ]
            ];
            m["flash.filters::GradientBevelFilter"] =
            [
                [ "distance",       4.0   ],
                [ "angle",          45    ],
                [ "colors",         null, formatColorArray ],
                [ "alphas",         null, formatArray ],
                [ "ratios",         null, formatArray ],
                [ "blurX",          4.0   ],
                [ "blurY",          4.0   ],
                [ "strength",       1     ],
                [ "quality",        1     ],
                [ "type",           BitmapFilterType.INNER, BitmapFilterType ],
                [ "knockout",       false ]
            ];
            m["flash.filters::GradientGlowFilter"] =
            [
                [ "distance",   4.0   ],
                [ "angle",      45    ],
                [ "colors",     null, formatColorArray ],
                [ "alphas",     null, formatArray ],
                [ "ratios",     null, formatArray ],
                [ "blurX",      4.0   ],
                [ "blurY",      4.0   ],
                [ "strength",   1.0   ],
                [ "quality",    1     ],
                [ "type",       BitmapFilterType.INNER, BitmapFilterType ],
                [ "knockout",   false ]
            ];
        }
        return $filterMetadata;
    }

    private static function formatHexColor(v:Number):String
    {
        return "0x" + StringUtil.padLeft(v.toString(16), 6, "0");
    }

    private static function formatArray(v:Array):String
    {
        return "[" + v.join(", ") + "]";
    }

    private static function formatColorArray(v:Array):String
    {
        var strArray:Array = [ ];
        var i:int;

        for (i = 0; i < v.length; i++)
        {
            strArray.push(formatHexColor(v[i]));
        }
        return formatArray(strArray);
    }

    private static function formatPoint(p:Point):String
    {
        return "new Point(" + p.x + ", " + p.y + ")";
    }
}
}

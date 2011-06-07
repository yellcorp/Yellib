package org.yellcorp.lib.serial
{
import org.yellcorp.lib.core.Stack;
import org.yellcorp.lib.serial.source.KeyValueSource;
import org.yellcorp.lib.serial.source.MapSource;
import org.yellcorp.lib.serial.source.VectorSource;
import org.yellcorp.lib.serial.target.InstanceTarget;
import org.yellcorp.lib.serial.target.KeyValueTarget;
import org.yellcorp.lib.serial.target.MapTarget;
import org.yellcorp.lib.serial.target.VectorTarget;
import org.yellcorp.lib.serial.util.MapMap;
import org.yellcorp.lib.serial.util.Reflector;

import flash.utils.describeType;
import flash.utils.getDefinitionByName;
import flash.utils.getQualifiedClassName;


public class Deserializer
{
    private var reflector:Reflector;
    private var classParsers:Object;
    private var constructors:Object;

    private var types:Stack;

    private var classParamByName:MapMap;
    private var classParamByClass:MapMap;

    public function Deserializer()
    {
        reflector = new Reflector();
        classParsers = { };
        constructors = { };
        types = new Stack();

        classParamByName = new MapMap();
        classParamByClass = new MapMap();

        setClassParser(Boolean, ParseUtil.parseBoolean);
        setClassParser(int, ParseUtil.parseInteger);
        setClassParser(uint, ParseUtil.parseUInteger);
        setClassParser(Number, ParseUtil.parseNumber);
        setClassParser(String, ParseUtil.parseString);
        setClassParser(XML, ParseUtil.parseXML);

        // TODO:
        // Class
        // Date
        // RegExp
        // Namespace
        // QName
    }

    public function setClassParser(clazz:Class, parseFunc:Function):void
    {
        var classString:String = getQualifiedClassName(clazz);
        classParsers[classString] = parseFunc;
    }

    public function setConstructor(clazz:Class, factoryFunc:Function):void
    {
        var classString:String = getQualifiedClassName(clazz);
        constructors[classString] = factoryFunc;
    }

    public function setClassParameterByName(
        parentClass:Class, propertyName:String, parameterClass:Class):void
    {
        var parentType:String = getQualifiedClassName(parentClass);
        var parameterType:String = getQualifiedClassName(parameterClass);

        classParamByName[parentType][propertyName] = parameterType;
    }

    public function setClassParameterByClass(
        parentClass:Class, propertyClass:Class, parameterClass:Class):void
    {
        var parentType:String = getQualifiedClassName(parentClass);
        var propertyType:String = getQualifiedClassName(propertyClass);
        var parameterType:String = getQualifiedClassName(parameterClass);

        classParamByName[parentType][propertyType] = parameterType;
    }

    public function deserialize(target:*, source:KeyValueSource):void
    {
        deserializeKeyValues(new InstanceTarget(target), source);
    }

    private function deserializeKeyValues(target:KeyValueTarget, source:KeyValueSource):void
    {
        for each (var key:* in target.getKeys())
        {
            target.setValue(key, getValue(source, key, target.getValueType(key)));
        }
    }

    private function getValue(source:KeyValueSource, key:String, type:String):*
    {
        var parseFunc:Function = classParsers[type];
        var newValue:*;

        if (parseFunc != null)
        {
            return parseFunc(source.getPrimitiveValue(key));
        }
        else if (reflector.isVectorType(type))
        {
            newValue = createInstance(type);
            populateVector(newValue, source, key, type);
            return newValue;
        }
        else if (reflector.isMapType(type))
        {
            newValue = createInstance(type);
            buildMap(newValue, source, key, type);
            return newValue;
        }
        else
        {
            newValue = createInstance(type);
            populateInstance(newValue, source, key, type);
            return newValue;
        }
    }

    private function populateInstance(instance:*, source:KeyValueSource, key:*, type:String):void
    {
        var subTarget:InstanceTarget;
        var subSource:KeyValueSource;

        subTarget = new InstanceTarget(instance);
        subSource = source.getKeyValueSource(key);

        types.push(type);
        deserializeKeyValues(subTarget, subSource);
        types.pop();
    }

    private function populateVector(vector:*, source:KeyValueSource, key:*, type:String):void
    {
        var vectorSource:VectorSource = source.getVectorSource(key);
        var valueType:String = getTypeParameter(type, key);
        var vectorTarget:VectorTarget =
            new VectorTarget(vector, vectorSource.length, valueType);

        types.push(type);
        deserializeKeyValues(vectorTarget, vectorSource);
        types.pop();
    }

    private function buildMap(object:*, source:KeyValueSource, key:*, type:String):void
    {
        var mapSource:MapSource = source.getMapSource(key);
        var valueType:String = getTypeParameter(type, key);
        var mapTarget:MapTarget =
            new MapTarget(object, mapSource.keys, valueType);

        types.push(type);
        deserializeKeyValues(mapTarget, mapSource);
        types.pop();
    }

    private function getTypeParameter(type:String, name:String):String
    {
        if (classParamByName.hasValue(types.top, name))
        {
            return classParamByName.getValue(types.top, name);
        }
        else if (classParamByClass.hasValue(types.top, type))
        {
            return classParamByName.getValue(types.top, type);
        }
        else
        {
            return reflector.getTypeParameter(type);
        }
    }

    private function createInstance(type:String):*
    {
        var factoryFunc:Function = constructors[type];
        var clazz:Class;

        if (factoryFunc != null)
        {
            return factoryFunc();
        }
        else
        {
            clazz = Class(getDefinitionByName(type));
            trace(describeType(clazz));
            // TODO: if clazz is an interface, this will throw a VerifyError #1001
            return new clazz();
        }
    }
}
}

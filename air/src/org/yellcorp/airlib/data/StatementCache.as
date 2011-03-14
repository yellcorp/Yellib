package org.yellcorp.airlib.data
{
import org.yellcorp.lib.core.MapUtil;
import org.yellcorp.lib.core.MultiMap;

import flash.data.SQLConnection;
import flash.data.SQLStatement;


public class StatementCache
{
    private var connection:SQLConnection;
    private var textCache:MultiMap;

    public function StatementCache(connection:SQLConnection)
    {
        this.connection = connection;
        textCache = new MultiMap();
    }

    public function statement(text:String, parameters:Object = null):SQLStatement
    {
        var sql:SQLStatement = textCache.pop(text);

        if (sql)
        {
            sql.clearParameters();
        }
        else
        {
            sql = new SQLStatement();
            sql.text = text;
        }
        sql.sqlConnection = connection;
        if (parameters) MapUtil.merge(parameters, sql.parameters);
        return sql;
    }

    public function recycle(sql:SQLStatement):void
    {
        textCache.push(sql.text, sql);
    }
}
}

package org.yellcorp.lib.validation.json
{
public class JSONValidationError extends Error
{
    public function JSONValidationError(message:* = "", id:* = 0)
    {
        super(message, id);
        name = "ObjectValidationError";
    }
}
}

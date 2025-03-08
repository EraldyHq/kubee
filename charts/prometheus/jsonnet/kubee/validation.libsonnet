
// Library of validation

{
    # All values should be present (ie default are in the values.yml file of kubee chart)
    # This function will return an error if the property is not
    getNestedPropertyOrThrow: function(obj, path)
      local parts = if std.type(path) == 'string' then
        std.split(path, '.')
      else
        path;

      local get(o, p) =
        if std.length(p) == 0 then
          o
        else if !std.isObject(o) then
          error path+" property was not found"
        else if !std.objectHas(o, p[0]) then
          error path+" property was not found"
        else
          get(o[p[0]], p[1:]);

    get(obj, parts),

  // use when the value should be present and not empty
  notNullOrEmpty: function (obj, path)
      local value = self.getNestedPropertyOrThrow(obj, path);
      assert value != '':  path+' has an empty value and is mandatory';
      value,
}


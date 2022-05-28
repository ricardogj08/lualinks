local conf = {
  sailor = {
    app_name = 'lualinks',
    -- If defined, default page will be a rendered lp as defined.
    -- Example: 'maintenance' will render /views/maintenance.lp
    default_static = nil,
    default_controller = 'main',
    default_action = 'index',
    theme  = 'default',
    layout = 'main',
    route_parameter  = 'r',
    default_error404 = 'error/404',
    -- default is false, should be true only in development environment
    enable_autogen = false,
    friendly_urls  = true,
    max_upload = 1024 * 1024,
    -- this will use db configuration named development
    environment = "development",
    -- false recommended for development, true recommended for production
    hide_stack_trace = false
  },

  db = {
    -- current environment
    development = {
      driver = 'mysql',
      host = '127.0.0.1',
      user = 'root',
      pass = 'root',
      dbname = 'lualinks'
    }
  },

  smtp = {
    server = '',
    user = '',
    pass = '',
    from = ''
  },

  lua_at_client = {
    -- starlight is default. Other options are moonshine, lua51js and luavmjs. They need to be downloaded.
    vm = 'starlight',
  },

  debug = {
    inspect = true
  }
}

return conf

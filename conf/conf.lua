local getenv = os.getenv
local conf = {
  sailor = {
    app_name = getenv('APP_NAME') or 'lualinks',
    app_url = getenv('APP_URL') or 'http://localhost:8080',
    -- If defined, default page will be a rendered lp as defined.
    -- Example: 'maintenance' will render /views/maintenance.lp
    default_static = nil,
    default_controller = 'user',
    default_action = 'login',
    theme  = 'default',
    layout = 'main',
    route_parameter  = 'r',
    default_error404 = 'error/404',
    -- default is false, should be true only in development environment
    enable_autogen = false,
    friendly_urls  = true,
    max_upload = 1024 * 1024,
    -- this will use db configuration named development
    environment = getenv('APP_ENV') or 'development',
    -- false recommended for development, true recommended for production
    hide_stack_trace = not getenv('APP_DEBUG')
  },

  db = {
    -- current environment
    development = {
      driver = 'mysql',
      host = '127.0.0.1',
      user = 'root',
      pass = 'root',
      dbname = 'lualinks'
    },
    production = {
      driver = getenv('DB_CONNECTION') or 'postgres',
      host = getenv('DB_HOST') or '127.0.0.1',
      user = getenv('DB_USERNAME') or 'root',
      pass = getenv('DB_PASSWORD') or 'root',
      dbname = getenv('DB_DATABASE') or 'lualinks'
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
    inspect = getenv('APP_DEBUG') or false
  }
}

return conf

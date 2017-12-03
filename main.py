import os
import tornado.ioloop
import tornado.web
import tornado.options
import functools
import logging
import signal
import time

from tornado.httpserver import HTTPServer

from Handlers import *

#Tornado app configuration
#part of the code is from my previous work at GlobalHack VI.


def get_url_list():
    user_handler_url_set = [
        # create a new user #post
        tornado.web.URLSpec(r"/text", MessageHandler),
    ]

    return user_handler_url_set

def get_settings():

    return {
        'login_url': '/auth/login',
        'debug': True
    }


def get_app():

    url_list = get_url_list()
    settings = get_settings()

    application = tornado.web.Application (
        url_list,
        **settings
    )

    return application

def get_ioloop():

    ioloop = tornado.ioloop.IOLoop.instance()
    return ioloop


def stop_server(server):

    logging.info('stopping server')
    server.stop()



#Tornado server run loop

def main():

    application = get_app()
    tornado.options.parse_command_line()
    server = HTTPServer(application)#, ssl_options=get_ssl())
    server.listen(8000)
    logging.info('starting server')
    ioloop = get_ioloop()
    try:
        ioloop.start()
    except KeyboardInterrupt:
        stop_server(server)
        logging.info('stopping server')


if __name__=='__main__':
    main()

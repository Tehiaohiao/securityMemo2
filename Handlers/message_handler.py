import tornado
import json
from tornado import gen
from .base_handler import *
import time
import re
import hashlib
from .helper import *
from boto.dynamodb2.table import Table

class MessageHandler(BaseHandler):

	@gen.coroutine
	def post(self):
		status = send_message(self.data['toNumber'], "+16182073798", self.data['message'])
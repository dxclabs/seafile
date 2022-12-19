# -*- coding: utf-8 -*-
SECRET_KEY = "blahblahblah"

DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.mysql',
        'NAME': 'seahub_db',
        'USER': 'seafile',
        'PASSWORD': 'seafile',
        'HOST': 'localhost',
        'PORT': '3306'
    }
}

SERVICE_URL = 'http://seafile.example.com:8000'

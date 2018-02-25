# -*- coding: utf-8 -*-

# Learn more: https://github.com/kennethreitz/setup.py

from setuptools import setup, find_packages


with open('README.md') as f:
    readme = f.read()

with open('LICENSE') as f:
    license = f.read()

setup(
    name='sweetrpg-models',
    version='0.1.0',
    description='Models for SweetRPG service apps',
    long_description=readme,
    author='Paul Schifferer',
    author_email='paul@schifferers.net',
    url='https://github.com/exsortis/sweetrpg-models',
    license=license,
    packages=find_packages(exclude=('tests', 'docs'))
)

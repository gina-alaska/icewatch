"""
setup script
"""
#~ try:
from setuptools import setup,find_packages
#~ except ImportError:
    #~ from distutils.core import setup

#~ impor

config = {
    'description': 'Assist to aspect conversion',
    'author': 'GINA',
    'url': '',
    'download_url': '',
    'author_email': 'TODO',
    'version': '0.0.1',
    'install_requires': ['numpy','pandas'],
    'packages': find_packages(),#['aaem', 'aaem.components', 'aaem_summaries', 'aaem.cli'],
    'scripts': [],
    #~ 'package_data': {'aaem_summaries': 
        #~ ['templates/*.html', 'templates/*.js', 'templates/*.css', 
        #~ 'templates/css/*','templates/fonts/*','templates/js/*']},
    'name': 'a2a'
}

setup(**config)

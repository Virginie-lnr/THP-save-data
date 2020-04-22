
require 'bundler'
Bundler.require

$:.unshift File.expand_path('./../lib', __FILE__)
require 'app/scrapper_mairie'
# require 'views/fichier_2'


# scrapper_result = ScrapperMairie.new
# print scrapper_result.get_all_emails

# save my list of emails as JSON:
# get_hash_into_JSON = ScrapperMairie.new
# get_hash_into_JSON.save_as_JSON

# # save list as spreadsheet
# get_hash_into_gsheet = ScrapperMairie.new
# get_hash_into_gsheet.save_as_spreadsheet

# save list as CSV :
get_hash_into_CSV = ScrapperMairie.new
get_hash_into_CSV.save_as_csv



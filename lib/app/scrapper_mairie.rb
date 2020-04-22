require 'rubygems'
require 'nokogiri'   
require 'open-uri'
require 'json'
require 'csv'
require 'google_drive'


class ScrapperMairie
# recuperer l'email de la mairie a partir de son url 
  def get_townhall_email(url)
      page = Nokogiri::HTML(open(url))
      return page.xpath('/html/body/div/main/section[2]/div/table/tbody/tr[4]/td[2]').text
  end

  # recuperer tous les liens url pour se deplacer de page en page 
  def get_townhall_urls
      page_list_department = Nokogiri::HTML(open("https://www.annuaire-des-mairies.com/val-d-oise.html"))
      get_townhall_url = []
      page_list_department.xpath('//a[@class="lientxt"]/@href').each do |url|
          get_townhall_url << "http://annuaire-des-mairies.com#{url.to_s[1..-1]}"
      end
      return get_townhall_url
  end
  #puts get_townhall_urls

  #fonction pour recuperer tous les emails des maires du 95
  def get_all_emails
      townhall_urls = get_townhall_urls
      array_of_emails = []
      hashObject = Hash.new
      townhall_urls.each do |url|        
        hashObject[url.to_s] = get_townhall_email(url.to_s)
      end
      return hashObject
  end 

# recuperer les données dans un fichier JSON:
  def save_as_JSON
    File.open("db/emails.JSON", "w+") do |hash_emails|
      hash_emails.write(JSON.pretty_generate(get_all_emails))
    end
  end

# save list of emails in a google spreadsheet
  def save_as_spreadsheet
    session = GoogleDrive::Session.from_config("config.json")
    ws = session.spreadsheet_by_key("1m0cyyGfBxhe8DweHTlOfyVYLFSjbOE8Yk6GQWpj920A").worksheets[0]
    ws[1, 1] = "Url"
    ws[1, 2] = "Emails"
    line = 2
    get_all_emails.each do |k,v| 
        ws[line, 1] = k
        ws[line, 2] = v        
      line += 1
    end
    ws.save
  end

# save list of emails in a CSV file
  def save_as_csv
    CSV.open("db/mairie_du_95_emails.csv", "w+") do |csv_object| # w+ creates a new file if it does not exit in reading/writting mode
      get_all_emails.each do |i|
        i.each do |k, v|
          csv_object << [k, v]
        end
      end
    end

  end

end
require 'csv'
class ImportJob < ApplicationJob
  queue_as :default

  # For Intercommunality
  INTER_SIREN = "siren_epci"
  INTER_NAME = "nom_complet"
  INTER_FORM = "form_epci"

  # For Commune
  COMMUNE_CODE_INSEE = "insee"
  COMUNE_NAME = "nom_com"
  COMUNE_POPULATION = "pop_total"
  HEADERS = ["dep_epci", "siren_epci", "nom_complet", "form_epci", "fisc_epci", "dep_com", "insee", "siren_com", "nom_com", "pop_total"]
  
  after_perform do |background_job|
    create_job_record(background_job)
  end

  def create_job_record background_job
    job = Job.find_by_name(self.class.to_s)
    file_name = background_job.arguments.first.to_s.split("/").last
    if job
      job.args << file_name
      job.save
    else
      job = Job.create(job_id: background_job.job_id, name: self.class.to_s, args: [file_name])
    end
  end

  def perform(file_path)
    job = Job.find_by_name(self.class.to_s)
    return if job && job.args.include?(file_path.to_s.split("/").last)
    
    CSV.read(file_path, :encoding => 'ISO-8859-1', col_sep: ';').each_with_index do |row, index|
      next if index == 0
      
      inter_form = row[HEADERS.find_index(INTER_FORM)] == "METRO" ? "met" : row[HEADERS.find_index(INTER_FORM)].to_s.downcase
      
      commune = Commune.new(code_insee: row[HEADERS.find_index(COMMUNE_CODE_INSEE)], 
                              name: row[HEADERS.find_index(COMUNE_NAME)],
                              population: row[HEADERS.find_index(COMUNE_POPULATION)])

      intercommune = Intercommunality.find_by_siren(row[HEADERS.find_index(INTER_SIREN)])

      if intercommune.nil?
        intercommune = Intercommunality.new(siren: row[HEADERS.find_index(INTER_SIREN)],
                                       name: row[HEADERS.find_index(INTER_NAME)],
                                       form: inter_form)

        intercommune.communes << commune
      else
        intercommune.communes << commune
      end

      intercommune.save
    end
  end
end

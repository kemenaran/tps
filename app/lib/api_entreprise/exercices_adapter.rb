class ApiEntreprise::ExercicesAdapter < ApiEntreprise::Adapter
  private

  def get_resource
    ApiEntreprise::API.exercices(@siret, @procedure_id)
  end

  def process_params
    exercices_array = data_source[:exercices].map do |exercice|
      exercice.slice(*attr_to_fetch)
    end

    { exercices_attributes: exercices_array }
  end

  def attr_to_fetch
    [
      :ca,
      :date_fin_exercice,
      :date_fin_exercice_timestamp
    ]
  end
end

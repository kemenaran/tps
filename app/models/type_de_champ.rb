class TypeDeChamp < ApplicationRecord
  enum type_champs: {
    text: 'text',
    textarea: 'textarea',
    date: 'date',
    datetime: 'datetime',
    number: 'number',
    checkbox: 'checkbox',
    civilite: 'civilite',
    email: 'email',
    phone: 'phone',
    address: 'address',
    yes_no: 'yes_no',
    drop_down_list: 'drop_down_list',
    multiple_drop_down_list: 'multiple_drop_down_list',
    pays: 'pays',
    regions: 'regions',
    departements: 'departements',
    engagement: 'engagement',
    header_section: 'header_section',
    explication: 'explication',
    dossier_link: 'dossier_link',
    piece_justificative: 'piece_justificative',
    siret: 'siret'
  }

  belongs_to :procedure

  scope :public_only, -> { where(private: false) }
  scope :private_only, -> { where(private: true) }
  scope :ordered, -> { order(order_place: :asc) }

  has_many :champ, inverse_of: :type_de_champ, dependent: :destroy do
    def build(params = {})
      super(params.merge(proxy_association.owner.params_for_champ))
    end

    def create(params = {})
      super(params.merge(proxy_association.owner.params_for_champ))
    end
  end
  has_one :drop_down_list

  has_one_attached :piece_justificative_template

  accepts_nested_attributes_for :drop_down_list

  validates :libelle, presence: true, allow_blank: false, allow_nil: false
  validates :type_champ, presence: true, allow_blank: false, allow_nil: false

  before_validation :check_mandatory
  before_save :remove_piece_justificative_template, if: -> { type_champ_changed? }

  def params_for_champ
    {
      private: private?,
      type: "Champs::#{type_champ.classify}Champ"
    }
  end

  def self.type_de_champs_list_fr
    type_champs.map { |champ| [I18n.t("activerecord.attributes.type_de_champ.type_champs.#{champ.last}"), champ.first] }
  end

  def check_mandatory
    if non_fillable?
      self.mandatory = false
    else
      true
    end
  end

  def non_fillable?
    type_champ.in?(['header_section', 'explication'])
  end

  def public?
    !private?
  end

  def self.type_champ_to_class_name(type_champ)
    "TypesDeChamp::#{type_champ.classify}TypeDeChamp"
  end

  private

  def remove_piece_justificative_template
    if type_champ != 'piece_justificative' && piece_justificative_template.attached?
      piece_justificative_template.purge_later
    end
  end
end

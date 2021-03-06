require "rails_helper"

RSpec.describe AvisMailer, type: :mailer do
  describe '.avis_invitation' do
    let(:avis) { create(:avis) }

    subject { described_class.avis_invitation(avis) }

    it { expect(subject.subject).to eq("Donnez votre avis sur le dossier nº #{avis.dossier.id} (#{avis.dossier.procedure.libelle})") }
    it { expect(subject.body).to include("Vous avez été invité par #{avis.claimant.email} à donner votre avis sur le dossier nº #{avis.dossier.id} de la procédure &quot;#{avis.dossier.procedure.libelle}&quot;.") }
    it { expect(subject.body).to include(avis.introduction) }
  end
end

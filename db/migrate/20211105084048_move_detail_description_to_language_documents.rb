class MoveDetailDescriptionToLanguageDocuments < ActiveRecord::Migration[6.0]
  def up
    %i[de fr it].each do |locale|
      ActiveStorage::Attachment.where(name: "detail_description_#{locale}")
                               .update_all(name: "language_document_#{locale}")
    end
  end

  def down
  end
end

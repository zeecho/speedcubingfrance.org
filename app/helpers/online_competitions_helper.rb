module OnlineCompetitionsHelper
  def contextual_class_for_comp(comp)
    comp.visible ?  "success" : "warning"
  end

  def started_text(comp)
    if comp.started?
      I18n.t("online_competitions.show.started")
    else
      I18n.t("online_competitions.show.will_start")
    end
  end

  def over_text(comp)
    if comp.over?
      I18n.t("online_competitions.show.ended")
    else
      I18n.t("online_competitions.show.will_end")
    end
  end

  def path_with_slug_or_id(comp)
    online_competition_path(comp.slug || comp.id)
  end

  def hint_for_scrambles(comp)
    "Fichier actuellement stocké: #{download_link_for_scrambles(@online_competition)}".html_safe
  end

  def scrambles_pdf_url(comp)
    if comp.scrambles_pdf.attached? && comp.scrambles_pdf.blob.id?
      rails_blob_path(comp.scrambles_pdf, disposition: "attachment")
    else
      "#"
    end
  end

  def download_link_for_scrambles(comp)
    # Without id, we're actually dealing with a non-saved attachment!
    # This can happen when updating a competition with a pdf and some other
    # invalid attributes.
    if comp.scrambles_pdf.attached? && comp.scrambles_pdf.blob.id?
      link_to(comp.scrambles_pdf.blob.filename, scrambles_pdf_url(comp))
    else
      "aucun"
    end
  end
end

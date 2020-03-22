module OnlineCompetitionsHelper
  def contextual_class_for_comp(comp)
    comp.visible ?  "success" : "warning"
  end

  def started_text(comp)
    if comp.started?
      "A débuté le"
    else
      "Débutera le"
    end
  end

  def over_text(comp)
    if comp.over?
      "S'est terminée le"
    else
      "Terminera le"
    end
  end

  def path_with_slug_or_id(comp)
    online_competition_path(comp.slug || comp.id)
  end
end

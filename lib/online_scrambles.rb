# frozen_string_literal: true

class OnlineScrambles
  #include ActiveModel::Model
  include ActiveModel::Validations

  # Access the raw data
  attr_accessor :raw

  validate :has_no_errors
  def has_no_errors
    raw["errors"].each do |e|
      errors.add(:scrambles, e)
    end
  end

  validate :has_all_scrambles
  def has_all_scrambles
    return unless any?
    state = raw["state"]
    Event.official.each do |e|
      unless state[e.id]
        errors.add(:scrambles, "missing scrambles for #{e.id}")
        next
      end
      event_data = state[e.id]
      expected = e.format.expected_solve_count
      scrambles = event_data["scrambles"]
      extras = event_data["extras"]
      if !scrambles.is_a?(Array)
        errors.add(:scrambles, "scrambles is not an array for #{e.id}")
      elsif scrambles.size != expected
        errors.add(:scrambles, "unexpected number of scrambles for #{e.id} (#{scrambles.size} vs #{expected})")
      end
      unless extras.is_a?(Array)
        errors.add(:scrambles, "extras is not an array for #{e.id}")
      end
    end
  end

  def initialize(json_arg = nil)
    self.raw = { "errors" => [] }
    return unless json_arg
    begin
      tnoodle_json = JSON.parse(json_arg.read)
    rescue JSON::ParserError
      self.raw["errors"] << "Couldn't parse the scrambles json file"
      return
    end

    self.raw["errors"].concat(JSON::Validator.fully_validate(OnlineScrambles.json_schema, tnoodle_json))
    return if self.raw["errors"].any?

    self.raw["state"] = {}
    tnoodle_json["sheets"].each do |sheet|
      # Only consider the first round for all
      next unless sheet["round"] == 1
      self.raw["state"][sheet["event"]] = {
        "scrambles" => sheet["scrambles"],
        "extras" => sheet["extraScrambles"],
      }
    end
  end

  def any?
    !self.raw["state"].nil?
  end

  def for(event_id)
    return {} unless any?
    self.raw["state"][event_id]
  end

  def self.load(json)
    OnlineScrambles.new.tap do |obj|
      if json
        data = JSON.parse(json) || {
          "errors" => []
        }
        obj.raw["errors"] = data["errors"]
        obj.raw["state"] = data["state"]
      end
    end
  end

  def self.dump(online_scrambles)
    online_scrambles ? JSON.dump({
      "errors" => online_scrambles.raw["errors"],
      "state" => online_scrambles.raw["state"],
    }) : nil
  end

  def self.json_schema
    {
      "type" => "object",
      "properties" => {
        "sheets" => {
          "type" => "array",
          "items" => {
            "type" => "object",
            "properties" => {
              "scrambles" => {
                "type" => "array",
                "items" => { "type" => "string" },
              },
              "extraScrambles" => {
                "type" => "array",
                "items" => { "type" => "string" },
              },
              "event" => { "type" => "string" },
              "round" => { "type" => "integer" },
            },
            "required" => ["scrambles", "extraScrambles", "event", "round"],
          },
        },
      },
      "required" => ["sheets"],
    }
  end
end

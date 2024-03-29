module GeneralHelpers
  RSpec::Matchers.define :have_react_component do |expected_mount_id|
    match do |page|
      @id = "react-mount-#{expected_mount_id}"

      @mount_node = page.find("div##{@id}")

      @valid_props =
        if @mount_node && @props
          @actual_props = JSON.parse(@mount_node['data-react-props'])
          @props.all? { |k, v| @actual_props[k.to_s] == v }
        else
          true
        end

      @mount_node && @valid_props
    end

    chain(:including_props) do |props|
      # Easiest way to deep stringify keys and values
      @props = JSON.parse(props.to_json)
    end

    description { "have react mount node #{@id}" }

    failure_message do
      str = "Expected to find react mount node #{@id}"
      str += " including props #{@props}, but got #{@actual_props}" if @props

      str
    end
  end
end

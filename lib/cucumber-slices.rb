
# This class scans a cucumber step file and a feature file, then
# matches the steps to the features.

class CucumberSlices

  Command = Struct.new :command, :regex, :code

  # determine if the line in a cucumber feature file is a feature
  # and return the kind, and the regexp associated with the feature.
  # Note that the regexp is returened as a string.
  def extract_regex line
    if line =~ /^(Then|Given|When|And)[ (]\/(.+)\/[^\/]+$/
      return [$1, $2]
    else
      return nil
    end
  end

  # scan step file for steps.
  # return an array of the steps in the Command struct
  def extract_steps file
    in_cmd_block = false
    cmd = nil
    code = []
    @steps = []
      file.each do |line|
        if line =~ /^end/
          in_cmd_block = false
          command = Command.new
          command.command, command.regex = extract_regex cmd
          command.code = code
          @steps << command
          code = []
        elsif line =~ /^(Given|When|Then|And)/
          in_cmd_block = true
          cmd = line
        else
          code << line if in_cmd_block
        end
      end
  end

  # match steps to features and output an array of lines
  # that can be displayed
  def splice_features(feature_file, lines=nil)
      splice = []
      count = 0
      feature_file.each do |line|
        count = count + 1
        if !lines or lines.include?(count)
          splice << "#{count.to_s} #{line}"
          if line =~ /^([ \t]+)(Given|When|Then|And) (.+)/
            indent = $1
            cmd = $2
            code = $3
            @steps.each do |step|
              if code =~ Regexp.new(step.regex)
                step.code.each do |l|
                  splice << "#{indent}#{l}"
                end
              end
            end
          end
        end
      end
      splice
  end
end

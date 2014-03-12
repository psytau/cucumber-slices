
class CucumberSlices

  Command = Struct.new :command, :regex, :code
  def extract_regex line
    if line =~ /^(Then|Given|When|And)[ (]\/(.+)\/[^\/]+$/
      return [$1, $2]
    else
      return nil
    end
  end

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

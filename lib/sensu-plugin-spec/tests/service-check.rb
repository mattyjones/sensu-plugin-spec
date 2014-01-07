module SensuPluginSpec
  class ServiceCheck < Minitest::Test
    include Helper

    def setup
      set_script "test/bin/service-check"
    end

    def test_ok
      run_script "-o"
      assert $?.exitstatus == 0
    end

    def test_warning
      run_script "-w"
      assert $?.exitstatus == 1
    end

    def test_critical
      run_script "-c"
      assert $?.exitstatus == 2
    end

    def test_unknown
      run_script "-u"
      assert $?.exitstatus == 3
    end

    def test_override
      output = run_script "-O"
      assert $?.exitstatus == 0 && !output.include?("argv =")
    end

    def test_fallthrough
      run_script
      assert $?.exitstatus == 1
    end

    def test_exception
      output = run_script "-f"
      assert $?.exitstatus == 2 && output.include?("failed")
    end

    def test_argv
      output = run_script "-o", "foo"
      assert $?.exitstatus == 0 && output.include?("argv = foo")
    end
  end
end

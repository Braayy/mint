require "./spec_helper"

describe "variable" do
  it "raises error" do
    example =
      <<-MINT
      store Main {
        state greeting : String = ""

        fun test : Void {
          do {
            next { greeting = greeting }
          }
        } where {
          greeting =
            if (greeting == "hello") {
              "bye"
            } else {
              "hello"
            }
        }
      }
      MINT

    ast = Mint::Parser.parse(example, "test.mint")
    ast.class.should eq(Mint::Ast)

    expect_raises(Mint::TypeChecker::Recursion) do
      type_checker = Mint::TypeChecker.new(ast)
      type_checker.check
    end
  end
end

describe "function" do
  it "raises error" do
    example =
      <<-MINT
      store Main {
        state greeting : String = ""

        fun test : Void {
          test()
        }
      }
      MINT

    ast = Mint::Parser.parse(example, "test.mint")
    ast.class.should eq(Mint::Ast)

    expect_raises(Mint::TypeChecker::Recursion) do
      type_checker = Mint::TypeChecker.new(ast)
      type_checker.check
    end
  end
end

describe "state" do
  it "raises error" do
    example =
      <<-MINT
      store Main {
        state greeting : String = greeting
      }
      MINT

    ast = Mint::Parser.parse(example, "test.mint")
    ast.class.should eq(Mint::Ast)

    expect_raises(Mint::TypeChecker::Recursion) do
      type_checker = Mint::TypeChecker.new(ast)
      type_checker.check
    end
  end
end

describe "property" do
  it "raises error" do
    example =
      <<-MINT
      component Main {
        property greeting : String = greeting

        fun render : Html {
          <div></div>
        }
      }
      MINT

    ast = Mint::Parser.parse(example, "test.mint")
    ast.class.should eq(Mint::Ast)

    expect_raises(Mint::TypeChecker::Recursion) do
      type_checker = Mint::TypeChecker.new(ast)
      type_checker.check
    end
  end
end

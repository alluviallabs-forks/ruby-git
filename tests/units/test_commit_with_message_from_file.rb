#!/usr/bin/env ruby
require 'test_helper'

class TestCommitWithMessageFromFile < Test::Unit::TestCase
  def setup
    clone_working_repo
  end
  
  def test_when_commit_message_is_nil
    message_file_path = File.join(@wdir, 'message.txt')
    create_file(message_file_path, multiline_message)

    git = Git.open(@wdir)
    git.add
    git.commit(nil, message_file_path: message_file_path)
    commits = git.log(1)
    
    actual_commit_message = commits.first.message 
    
    assert_equal(multiline_message, actual_commit_message)
  end
  
  def test_message_and_file_are_both_given
    message_file_path = File.join(@wdir, 'message.txt')
    create_file(message_file_path, multiline_message)

    git = Git.open(@wdir)
    git.add
    assert_raises ArgumentError do
      git.commit('ANY_NON_NIL_STRING', message_file_path: message_file_path)
    end
  end
  
  private
  
  def multiline_message
    <<~'TXT'.strip
      Some
        multiline message
      with special chars:
        !@#$%^&*()__+1234567890-
    TXT
  end
end

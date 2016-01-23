require "active_record"
require "active_snapshot/repository"
require "active_snapshot/result"
require "active_snapshot/snapshot"
require "active_snapshot/version"

module ActiveSnapshot
  class << self
    def take(*ar_relations)
      repository.take(ar_relations)
    end

    def go_to(revision)
      repository.go_to(revision)
    end

    def go_to_last_revision
      repository.go_to_last_revision
    end

    def repository
      @repository ||= Repository.new
    end

    def clear_repository
      repository.clear
    end
  end
end

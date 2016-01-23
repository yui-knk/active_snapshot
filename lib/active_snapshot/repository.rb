module ActiveSnapshot
  class Repository
    attr_reader :snapshots

    def initialize
      @snapshots = []
    end

    def take(ar_relations)
      results = ar_relations.map do |ar_relation|
        klass = ar_relation.klass
        # 
        result = klass.connection.exec_query(ar_relation.to_sql)
        Result.build_from_ar_result(klass, result)
      end

      @snapshots << { revision: generate_revision, snapshot: Snapshot.new(results) }
    end

    def go_to(revision)
      snapshot = select_snapshot(revision)
      snapshot.apply
    end

    def go_to_last_revision
      go_to(last_revision)
    end

    def revisions
      @snapshots.map {|snapshot| snapshot[:revision] }
    end

    def clear
      @snapshots = []      
    end

    private
      def generate_revision
        Time.now.strftime("%Y%m%d%H%M%S")
      end

      def select_snapshot(revision)
        # raise
        snapshot = @snapshots.find {|snapshot| snapshot[:revision] == revision }
        snapshot[:snapshot]
      end

      def last_revision
        @snapshots.last[:revision]
      end
  end
end

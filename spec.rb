Post = Struct.new(:title, :tags, :author, :published)
post = Post.new('Specification pattern', %w(ruby patterns), 'Calin', false)

module Spec
  module Post
    class WithTitle
      def is_satisfied_by?(post)
        !post.title.empty?
      end
    end

    class WithTags
      def is_satisfied_by?(post)
        !post.tags.to_a.empty?
      end
    end

    class Published
      def is_satisfied_by?(post)
        !!post.published
      end
    end
  end

  class Composite
    def initialize(specs)
      @specs = { truthy: Array(specs), falsy: []  }
    end

    def is_satisfied_by?(candidate)
      truthy_check = ->(spec) { spec.new.is_satisfied_by?(candidate) }
      falsy_check = ->(spec) { !spec.new.is_satisfied_by?(candidate) }

      @specs[:truthy].all?(&truthy_check) && @specs[:falsy].all?(&falsy_check)
    end

    def and(specs)
      @specs[:truthy] = (@specs[:truthy] + Array(specs)).uniq
      self
    end

    def not(specs)
      @specs[:falsy] = (@specs[:falsy] + Array(specs)).uniq
      self
    end
  end
end

p Spec::Post::WithTitle.new.is_satisfied_by?(post)

spec = Spec::Composite.new(Spec::Post::WithTitle).and(Spec::Post::WithTags).not(Spec::Post::Published)
p spec.is_satisfied_by?(post)


# frozen_string_literal: true

module Load
  def save(object, file_path)
    File.new(file_path, 'w+') unless File.exist?(file_path)
    File.open(file_path, 'a') { |file| file.write(YAML.dump(object)) }
  end

  def load_statistics(file_path)
    rating(load_documents(file_path))
  end

  def load_documents(file_path)
    YAML.load_documents(File.open(file_path))
  end

  def sorting_by_attemt(storge)
    storge.sort_by { |game| game[:attempts_used] }
  end

  def sorting_by_hint(storge)
    storge.sort_by { |game| game[:hints_used] }
  end

  def groupping_by_difficulty(storge)
    storge.group_by { |game| game[:difficulty] }
  end

  def sorted(storge)
    groupping_by_difficulty(sorting_by_hint(sorting_by_attemt(storge)))
  end

  def rating(storage)
    sorted(storage).values.flatten
  end
  end

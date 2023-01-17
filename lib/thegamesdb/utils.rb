# frozen_string_literal: true

module Gamesdb
  # Several reusable functions
  module Utils
    class << self
      def process_logo(data, id)
        logo = data['images'][id.to_s].select { |a| a['type'] == 'clearlogo' }
        logo.empty? ? '' : logo.first['filename']
      end

      def process_fanart(data, id)
        fanart = select_images(data, id, 'fanart')
        return [] if fanart.empty?

        fanart.map { |art| build_individual_fanart(art) }
      end

      def process_covers(data, id)
        covers = {}
        boxart = select_images(data, id, 'boxart')
        return [] if boxart.empty?

        boxart.each do |art|
          width, height = art['resolution'].split('x') unless art['resolution'].nil?
          covers[art['side'].to_sym] = art_structure(art, width, height)
        end
        covers
      end

      def build_individual_fanart(art)
        width, height = art['resolution'].split('x') unless art['resolution'].nil?
        art_structure(art, width, height)
      end

      def art_structure(art, width, height)
        {
          url: art['filename'],
          resolution: art['resolution'],
          width: width,
          height: height
        }
      end

      def process_screenshots(data, id)
        select_images(data, id, 'screenshot').map do |b|
          Gamesdb::Utils.symbolize_keys(b)
        end
      end

      def select_images(data, id, image_type)
        data['images'][id.to_s].select do |a|
          a['type'] == image_type
        end
      end

      def symbolize_keys(hash)
        new_hash = {}
        hash.each_key do |key|
          new_hash[key.to_sym] = hash.delete(key)
        end
        new_hash
      end
    end
  end
end

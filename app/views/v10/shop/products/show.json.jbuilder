# meta info
json.partial! 'common/meta'
# code & msg
json.partial! 'common/api_result', api_result: ApiResult.success_result
# data
json.data do
  json.product do
    json.id             @product.id
    json.category_id    @product.category_id
    json.title          @product.title
    json.icon           @product.preview_icon
    json.price          @product.master.price
    json.description    @product.description

    json.master do
      json.partial! 'variant', variant: @product.master
    end

    json.variants do
      json.array! @product.variants, partial: 'variant', as: :variant
    end

    json.has_variants @product.variants.present?

    json.option_types do
      json.partial! 'option_types', product: @product
    end
  end
end
defmodule Formex.Template.Bootstrap do
  use Formex.Template, :helper

  @moduledoc false

  @spec generate_field_html(Form.t, Field.t) :: any
  def generate_field_html(form, field) do

    type = field.type
    opts = field.opts
    data = field.data
    phoenix_opts = if opts[:phoenix_opts], do: opts[:phoenix_opts], else: []

    class = if opts[:class], do: opts[:class], else: ""

    args = [form.phoenix_form, field.name]
    args = args ++ cond do
      Enum.member? [:select, :multiple_select], type ->
        [data[:choices], Keyword.merge([class: class<>" form-control"], phoenix_opts) ]

      Enum.member? [:checkbox], type ->
        [Keyword.merge([class: class], phoenix_opts) ]

      Enum.member? [:file_input], type ->
        [Keyword.merge([class: class], phoenix_opts) ]

      true ->
        [Keyword.merge([class: class<>" form-control"], phoenix_opts) ]
    end

    input = render_phoenix_input(field, args)

    cond do
      Enum.member? [:checkbox], type ->
        content_tag(:div, [
          content_tag(:label, [
            input
            ])
          ], class: "checkbox")

      true ->
        input
    end
  end

  @spec generate_label_html(Form.t, Field.t, String.t) :: Phoenix.HTML.safe
  def generate_label_html(form, field, class \\ "") do
    Phoenix.HTML.Form.label(
      form.phoenix_form,
      field.name,
      field.label,
      class: "control-label "<>class
    )
  end

  #

  def attach_addon(field_html, field) do
    if field.opts[:addon] do
      addon = content_tag(:div, field.opts[:addon], class: "input-group-addon")
      content_tag(:div, [field_html, addon], class: "input-group" )
    else
      field_html
    end
  end

  def attach_error(tags, form, field) do
    if has_error(form, field) do
      error_text  = translate_error(form, field)
      error_field = content_tag(:span, error_text, class: "help-block")
      tags ++ [error_field]
    else
      tags
    end
  end

  def attach_error_class(wrapper_class, form, field) do
    if has_error(form, field) do
      wrapper_class ++ ["has-error"]
    else
      wrapper_class
    end
  end

  def attach_required_class(wrapper_class, field) do
    if field.required do
      wrapper_class ++ ["required"]
    else
      wrapper_class
    end
  end

end

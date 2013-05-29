Chaplin = require 'chaplin'
View = require 'views/base/view'
template = require 'views/templates/charts/activity-chart'

module.exports = class ActivityChartView extends View
  el: $('#activity-chart-container')
  autoRender: true
  autoAttach: true
  template: template

  politics_color = "#F7464A"
  business_color = "#E2EAE9"
  technology_color = "#D4CCC5"
  sports_color = "#ccc"
  science_color = "#9c9c9c"
  entertainment_color = "#000"
  other_color = "#c30000"

  parsePageVisits: ->
    page_visit_count = @collection.length
    page_visits = @collection.models
    page_visits_dict = { 'politics': 0, 'business': 0, 'technology': 0, 'sports': 0, 'science': 0, 'entertainment': 0, 'other': 0 }

    for page_visit in page_visits
      counter = (page_visit.attributes.updated_at - page_visit.attributes.created_at)/1000
      page_visits_dict[page_visit.attributes.category] += counter

    return page_visits_dict

  initChart: ->
    page_visits_by_category = @parsePageVisits()

    nv.addGraph(->
      chart = nv.models.pieChart().x((d) -> return d.key).values((d) -> return d).showLabels(true).color(d3.scale.category10().range()).labelThreshold(.05).donut(true)

      data = [
        {
          key: "Politics",
          y: page_visits_by_category['politics']
        },
        {
          key: "Business",
          y: page_visits_by_category['business']
        },
        {
          key: "Technology",
          y: page_visits_by_category['technology']
        },
        {
          key: "Sports",
          y: page_visits_by_category['sports']
        },
        {
          key: "Science",
          y: page_visits_by_category['science']
        },
        {
          key: "Entertainment",
          y: page_visits_by_category['entertainment']
        },
        {
          key: "Other",
          y: page_visits_by_category['other']
        }
      ]

      d3.select('#chart svg').datum([data]).transition().duration(1200).call(chart)

      return chart
      )

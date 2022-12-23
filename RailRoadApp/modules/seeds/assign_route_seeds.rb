module AssignRouteSeeds
  def assign_routes
    trains['P00-01'].take_route(routes['s1 - s2'])
    trains['P00-02'].take_route(routes['s1 - s2'])
    trains['P00-03'].take_route(routes['s3 - s4'])
    trains['C00-01'].take_route(routes['s3 - s4'])
    trains['C00-02'].take_route(routes['s5 - s6'])
    trains['C00-03'].take_route(routes['s5 - s6'])
  end
end

class PowersController < ApplicationController
  def update
    Power.update(
      iidxid: "1111-1111",
      sp8s: "1",
      sp9s: "1",
      sp10s: "1",
      sp11s: "1",
      sp12s: "1",
      sps: "1",
      sp11c: "1",
      sp12c: "1",
      spc: "1"
    )
    render text: "update succeeded"
  end
end

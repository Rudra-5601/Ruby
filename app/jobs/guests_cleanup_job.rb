class GuestsCleanupJob < ApplicationJob
  queue_as :default

  def perform(*guests)
    # Do something later
	# Enqueue a job to be performed as soon as the queuing system is
    # free.
     GuestsCleanupJob.perform_later guest
	 # Enqueue a job to be performed tomorrow at noon.
     GuestsCleanupJob.set(wait_until: Date.tomorrow.noon).perform_later(guest)
	 # Enqueue a job to be performed 1 week from now.
     GuestsCleanupJob.set(wait: 1.week).perform_later(guest)
	 # `perform_now` and `perform_later` will call `perform` under the hood so
     # you can pass as many arguments as defined in the latter.
     GuestsCleanupJob.perform_later(guest1, guest2, filter: "some_filter")


  end
end

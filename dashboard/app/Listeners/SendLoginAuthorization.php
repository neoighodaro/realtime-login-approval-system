<?php

namespace App\Listeners;

use Illuminate\Queue\InteractsWithQueue;
use Illuminate\Contracts\Queue\ShouldQueue;
use App\Events\LoginAuthorizationRequested;
use Pusher\PushNotifications\PushNotifications;

class SendLoginAuthorization implements ShouldQueue
{
    use InteractsWithQueue;

    /**
     * @var \Pusher\PushNotifications\PushNotifications
     */
    protected $beams;

    /**
     * Create the event listener.
     *
     * @param \Pusher\PushNotifications\PushNotifications $pushNotifications
     */
    public function __construct(PushNotifications $pushNotifications)
    {
        $this->beams = $pushNotifications;
    }

    /**
     * Handle the event.
     *
     * @param  \App\Events\LoginAuthorizationRequested  $event
     * @return void
     */
    public function handle(LoginAuthorizationRequested $event)
    {
        $payload = [
            'title' => 'Dashboard',
            'body' => 'Dashboard just sent a new approval request',
        ];

        // Interest: auth-janedoe-at-pushercom
        $interests = ['auth-' . str_slug($event->email)];

        $this->beams->publishToInterests($interests, [
            'apns' => [
                'aps' => [
                    'alert' => $payload,
                    'category' => 'LoginActions',
                    'payload' => ['hash' => $event->hash, 'email' => $event->email],
                ],
            ],
        ]);
    }
}

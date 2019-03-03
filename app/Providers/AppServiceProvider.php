<?php

namespace App\Providers;

use Illuminate\Support\ServiceProvider;
use Pusher\PushNotifications\PushNotifications;

class AppServiceProvider extends ServiceProvider
{
    /**
     * Register any application services.
     *
     * @return void
     */
    public function register()
    {
        $this->app->bind(PushNotifications::class, function () {
            $config = config('broadcasting.connections.pusher.beams');

            return PushNotifications([
                'secretKey' => $config['secret_key'] ?? '',
                'instanceId' => $config['instance_id'] ?? '',
            ]);
        });
    }

    /**
     * Bootstrap any application services.
     *
     * @return void
     */
    public function boot()
    {
    }
}

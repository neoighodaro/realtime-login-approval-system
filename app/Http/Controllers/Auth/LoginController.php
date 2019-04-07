<?php

namespace App\Http\Controllers\Auth;

use Illuminate\Support\Str;
use Illuminate\Http\Request;
use App\Events\LoginAuthorized;
use Illuminate\Support\Facades\Hash;
use App\Http\Controllers\Controller;
use App\Events\LoginAuthorizationRequested;
use Illuminate\Foundation\Auth\AuthenticatesUsers;

class LoginController extends Controller
{
    /*
    |--------------------------------------------------------------------------
    | Login Controller
    |--------------------------------------------------------------------------
    |
    | This controller handles authenticating users for the application and
    | redirecting them to your home screen. The controller uses a trait
    | to conveniently provide its functionality to your applications.
    |
    */

    use AuthenticatesUsers;

    /**
     * Where to redirect users after login.
     *
     * @var string
     */
    protected $redirectTo = '/home';

    /**
     * Create a new controller instance.
     *
     * @return void
     */
    public function __construct()
    {
        $this->middleware('guest')->except('logout');
    }

    /**
     * @param Request $request
     * @return void
     */
    public function confirmLogin(Request $request)
    {
        $this->validateLogin($request);

        if ($this->hasTooManyLoginAttempts($request)) {
            $this->fireLockoutEvent($request);

            return $this->sendLockoutResponse($request);
        }

        if ($this->guard()->validate($this->credentials($request))) {
            $username = $request->get($this->username());
            $hashKey = sha1($username . '_' . Str::random(32));
            $unhashedLoginHash = $hashKey . '.' . Str::random(32);

            // Store the hash for 5 minutes...
            cache()->put("{$hashKey}_login_hash", Hash::make($unhashedLoginHash), now()->addMinutes(5));

            event(new LoginAuthorizationRequested($unhashedLoginHash, $username));

            return ['status' => true];
        }

        $this->incrementLoginAttempts($request);

        return $this->sendFailedLoginResponse($request);
    }

    /**
     * @param Request $request
     * @return void
     */
    public function clientAuthorized(Request $request)
    {
        $request->validate(['hash' => 'required|string']);

        $sentHash = $request->get('hash');
        [$hashKey] = explode('.', $sentHash);
        $storedHash = cache()->get($hashKey . '_login_hash');

        if (!Hash::check($sentHash, $storedHash)) {
            abort(422);
        }

        event(new LoginAuthorized($sentHash));

        return ['status' => true];
    }

    /**
     * @param Request $request
     * @return void
     */
    public function authorizeLogin(Request $request)
    {
        $request->validate([
            'hash' => 'required|string',
            'password' => 'required|string',
            $this->username() => 'required|string',
        ]);

        $sentHash = $request->get('hash');
        [$hashKey] = explode('.', $sentHash);
        $storedHash = cache()->get($hashKey . '_login_hash');

        if (!Hash::check($sentHash, $storedHash) || !$this->attemptLogin($request)) {
            abort(422);
        }

        return ['status' => true];
    }
}

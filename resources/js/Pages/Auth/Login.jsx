import { useEffect } from 'react';
import { Head, Link, useForm } from '@inertiajs/react';

export default function Login({ status, canResetPassword }) {
    const { data, setData, post, processing, errors, reset } = useForm({
        email: '',
        password: '',
        remember: false,
    });

    useEffect(() => {
        return () => {
            reset('password');
        };
    }, []);

    const submit = (e) => {
        e.preventDefault();
        post(route('login'));
    };

    return (
        <div className="min-vh-100 d-flex align-items-center justify-content-center bg-light">
            <Head title="Login" />
            <div className="container">
                <div className="row justify-content-center">
                    <div className="col-md-6 col-lg-5">
                        <div className="card shadow-lg border-0">
                            <div className="card-body p-5">
                                <h2 className="text-center mb-4 fw-bold">Welcome Back</h2>
                                <p className="text-center text-muted mb-4">Sign in to your account</p>
                                
                                {status && (
                                    <div className="alert alert-success" role="alert">
                                        {status}
                                    </div>
                                )}

                                <form onSubmit={submit}>
                                    <div className="mb-3">
                                        <label htmlFor="email" className="form-label fw-semibold">Email Address</label>
                                        <input
                                            id="email"
                                            type="email"
                                            className={`form-control form-control-lg ${errors.email ? 'is-invalid' : ''}`}
                                            value={data.email}
                                            onChange={(e) => setData('email', e.target.value)}
                                            required
                                            autoFocus
                                            autoComplete="username"
                                            placeholder="name@example.com"
                                        />
                                        {errors.email && (
                                            <div className="invalid-feedback">{errors.email}</div>
                                        )}
                                    </div>

                                    <div className="mb-3">
                                        <label htmlFor="password" className="form-label fw-semibold">Password</label>
                                        <input
                                            id="password"
                                            type="password"
                                            className={`form-control form-control-lg ${errors.password ? 'is-invalid' : ''}`}
                                            value={data.password}
                                            onChange={(e) => setData('password', e.target.value)}
                                            required
                                            autoComplete="current-password"
                                            placeholder="Enter your password"
                                        />
                                        {errors.password && (
                                            <div className="invalid-feedback">{errors.password}</div>
                                        )}
                                    </div>

                                    <div className="mb-3 form-check">
                                        <input
                                            id="remember"
                                            type="checkbox"
                                            className="form-check-input"
                                            checked={data.remember}
                                            onChange={(e) => setData('remember', e.target.checked)}
                                        />
                                        <label htmlFor="remember" className="form-check-label">
                                            Remember me
                                        </label>
                                    </div>

                                    <div className="d-grid gap-2">
                                        <button 
                                            type="submit" 
                                            className="btn btn-primary btn-lg"
                                            disabled={processing}
                                        >
                                            {processing && (
                                                <span className="spinner-border spinner-border-sm me-2" role="status"></span>
                                            )}
                                            Sign In
                                        </button>
                                    </div>

                                    <div className="mt-4 text-center">
                                        {canResetPassword && (
                                            <Link href={route('password.request')} className="text-decoration-none me-3">
                                                Forgot Password?
                                            </Link>
                                        )}
                                        <Link href={route('register')} className="text-decoration-none">
                                            Create Account
                                        </Link>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    );
}

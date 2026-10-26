import { useEffect } from 'react';
import { Head, Link, useForm } from '@inertiajs/react';

export default function Register() {
    const { data, setData, post, processing, errors, reset } = useForm({
        name: '',
        email: '',
        password: '',
        password_confirmation: '',
    });

    useEffect(() => {
        return () => {
            reset('password', 'password_confirmation');
        };
    }, []);

    const submit = (e) => {
        e.preventDefault();
        post(route('register'));
    };

    return (
        <div className="min-vh-100 d-flex align-items-center justify-content-center bg-light">
            <Head title="Register" />
            <div className="container">
                <div className="row justify-content-center">
                    <div className="col-md-6 col-lg-5">
                        <div className="card shadow-lg border-0">
                            <div className="card-body p-5">
                                <h2 className="text-center mb-4 fw-bold">Create Account</h2>
                                <p className="text-center text-muted mb-4">Join us today</p>

                                <form onSubmit={submit}>
                                    <div className="mb-3">
                                        <label htmlFor="name" className="form-label fw-semibold">Full Name</label>
                                        <input
                                            id="name"
                                            type="text"
                                            className={`form-control form-control-lg ${errors.name ? 'is-invalid' : ''}`}
                                            value={data.name}
                                            onChange={(e) => setData('name', e.target.value)}
                                            required
                                            autoFocus
                                            autoComplete="name"
                                            placeholder="John Doe"
                                        />
                                        {errors.name && (
                                            <div className="invalid-feedback">{errors.name}</div>
                                        )}
                                    </div>

                                    <div className="mb-3">
                                        <label htmlFor="email" className="form-label fw-semibold">Email Address</label>
                                        <input
                                            id="email"
                                            type="email"
                                            className={`form-control form-control-lg ${errors.email ? 'is-invalid' : ''}`}
                                            value={data.email}
                                            onChange={(e) => setData('email', e.target.value)}
                                            required
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
                                            autoComplete="new-password"
                                            placeholder="Create a password"
                                        />
                                        {errors.password && (
                                            <div className="invalid-feedback">{errors.password}</div>
                                        )}
                                    </div>

                                    <div className="mb-3">
                                        <label htmlFor="password_confirmation" className="form-label fw-semibold">
                                            Confirm Password
                                        </label>
                                        <input
                                            id="password_confirmation"
                                            type="password"
                                            className={`form-control form-control-lg ${errors.password_confirmation ? 'is-invalid' : ''}`}
                                            value={data.password_confirmation}
                                            onChange={(e) => setData('password_confirmation', e.target.value)}
                                            required
                                            autoComplete="new-password"
                                            placeholder="Confirm your password"
                                        />
                                        {errors.password_confirmation && (
                                            <div className="invalid-feedback">{errors.password_confirmation}</div>
                                        )}
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
                                            Create Account
                                        </button>
                                    </div>

                                    <div className="mt-4 text-center">
                                        <Link href={route('login')} className="text-decoration-none">
                                            Already have an account? Sign in
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

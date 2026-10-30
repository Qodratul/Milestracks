export interface RegisterInput {
  readonly displayName: string;
  readonly email: string;
  readonly password: string;
  readonly locale: "id" | "en";
  readonly timezone?: string;
}

export interface LoginInput {
  readonly email: string;
  readonly password: string;
}

export interface GoogleAuthInput {
  readonly idToken: string;
  readonly locale?: "id" | "en";
  readonly timezone?: string;
}

export interface AuthenticatedUser {
  readonly id: string;
}

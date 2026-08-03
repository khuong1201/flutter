export class User {
  constructor(
    public readonly id: string,
    public readonly email: string,
    public readonly fullName: string,
    public readonly targetLanguage: string,
    public xpPoints: number,
    public avatarUrl?: string | null,
    public targetLevel?: string | null,
    public provider?: string | null,
    public providerId?: string | null,
    public currentStreak: number = 0,
    public longestStreak: number = 0,
    public lastStudyDate?: Date | null,
    public readonly passwordHash?: string | null,
    public readonly createdAt?: Date,
    public readonly updatedAt?: Date,
  ) {}
}

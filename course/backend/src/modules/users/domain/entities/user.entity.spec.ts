import { User } from './user.entity';

describe('User Entity', () => {
  it('should create a valid user instance', () => {
    const user = new User(
      'uuid-1234',
      'test@example.com',
      'Test User',
      'ja',
      100,
      'http://avatar.com/1.png',
      'N5',
      null,
      null,
      5,
      10,
      new Date(),
      'hashed_password',
    );

    expect(user.id).toBe('uuid-1234');
    expect(user.email).toBe('test@example.com');
    expect(user.passwordHash).toBe('hashed_password');
    expect(user.fullName).toBe('Test User');
    expect(user.targetLanguage).toBe('ja');
    expect(user.xpPoints).toBe(100);
    expect(user.avatarUrl).toBe('http://avatar.com/1.png');
    expect(user.targetLevel).toBe('N5');
    expect(user.currentStreak).toBe(5);
  });

  it('should be able to update xpPoints', () => {
    const user = new User(
      'uuid-1234',
      'test@example.com',
      'Test User',
      'ja',
      0,
    );

    user.xpPoints += 50;
    expect(user.xpPoints).toBe(50);
  });
});

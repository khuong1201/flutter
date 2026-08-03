import { ReviewLog } from '../entities/review-log.entity';

export const REVIEW_LOG_REPOSITORY = 'REVIEW_LOG_REPOSITORY';

export interface IReviewLogRepository {
  create(log: ReviewLog): Promise<ReviewLog>;
}

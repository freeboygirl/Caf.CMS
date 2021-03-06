
GO
/****** Object:  SitedProcedure [dbo].[ArticleTagCountLoadAll]    Script Date: 2015/6/2 14:53:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


Create PROCEDURE [dbo].[ArticleTagCountLoadAll]
(
	@SiteId int
)
AS
BEGIN
	SET NOCOUNT ON
	
	SELECT pt.Id as [ArticleTagId], COUNT(p.Id) as [ArticleCount]
	FROM ArticleTag pt with (NOLOCK)
	LEFT JOIN Article_ArticleTag_Mapping pptm with (NOLOCK) ON pt.[Id] = pptm.[ArticleTag_Id]
	LEFT JOIN Article p with (NOLOCK) ON pptm.[Article_Id] = p.[Id]
	WHERE
		p.[Deleted] = 0
		AND p.StatusId = 0
		AND (@SiteId = 0 or (p.LimitedToSites = 0 OR EXISTS (
			SELECT 1 FROM [SiteMapping] sm
			WHERE [sm].EntityId = p.Id AND [sm].EntityName = 'Article' and [sm].SiteId=@SiteId
			)))
	GROUP BY pt.Id
	ORDER BY pt.Id
END

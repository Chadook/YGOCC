--Hierophant of the Gemini
function c23165431.initial_effect(c)
	--Xyz Summon
	c:EnableReviveLimit()
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsType,TYPE_NORMAL),4,2)
	--Negate Summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(23165431,0))
	e1:SetCategory(CATEGORY_DISABLE_SUMMON+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_SPSUMMON)
	e1:SetCountLimit(1)
	e1:SetCondition(c23165431.condition)
	e1:SetCost(c23165431.cost)
	e1:SetTarget(c23165431.target)
	e1:SetOperation(c23165431.operation)
	c:RegisterEffect(e1)
end
function c23165431.filter(c)
	return c:IsType(TYPE_PENDULUM)
end
function c23165431.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()==0 and eg:IsExists(c23165431.filter,1,nil)
end
function c23165431.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c23165431.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=eg:Filter(c23165431.filter,nil)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c23165431.operation(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=eg:Filter(c23165431.filter,nil)
	Duel.NegateSummon(g)
	local ct=Duel.Destroy(g,REASON_EFFECT)
	Duel.Damage(tp,ct*800,REASON_EFFECT)
end
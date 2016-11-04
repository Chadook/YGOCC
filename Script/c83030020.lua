--Carefree Retreat
function c83030020.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_DESTROYED)
	e1:SetCountLimit(1,83030020+EFFECT_COUNT_CODE_OATH)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCondition(c83030020.condition)
	e1:SetTarget(c83030020.target)
	e1:SetOperation(c83030020.activate)
	c:RegisterEffect(e1)
	--act qp in hand/deck
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	e2:SetRange(LOCATION_HAND+LOCATION_DECK)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetType(EFFECT_TYPE_ACTIVATE+EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_DECK)
	e3:SetCost(c83030020.cost)
	c:RegisterEffect(e3)
end
function c83030020.cfilter(c)
	return c:IsFaceup() and c:IsCode(83030019)
end
function c83030020.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsCode,1,nil,83030019) 
		and (not Duel.IsExistingMatchingCard(c83030020.cfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) 
		or Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil,83030019))
end
function c83030020.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
	Duel.MoveToField(e:GetHandler(),tp,tp,LOCATION_SZONE,POS_FACEUP,true)
end
function c83030020.filter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x833) and c:IsAbleToDeck() and c:GetOwner()==tp
end
function c83030020.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c83030020.filter,tp,0,LOCATION_MZONE,1,nil,tp) end
	local g=Duel.GetMatchingGroup(c83030020.filter,tp,0,LOCATION_MZONE,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,g:GetCount()*500)
end
function c83030020.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c83030020.filter,tp,0,LOCATION_MZONE,nil,tp)
	Duel.SendtoDeck(g,nil,1,REASON_EFFECT)
	local og=Duel.GetOperatedGroup()
	local ct=og:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)
	local ogd=og:Filter(Card.IsLocation,nil,LOCATION_DECK)
	if ogd:GetCount()>1 then
		for i=1,ogd:GetCount() do
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(83030020,0))
			local mg=ogd:Select(tp,1,1,nil)
			ogd:Sub(mg)
			Duel.MoveSequence(mg:GetFirst(),1)
		end
	end
	Duel.Damage(1-tp,ct*500,REASON_EFFECT)
	e:GetHandler():CancelToGrave(false)
end

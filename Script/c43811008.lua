--Whispers of the Phantasm
function c43811008.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,43811008+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c43811008.cost)
	e1:SetTarget(c43811008.target)
	e1:SetOperation(c43811008.activate)
	c:RegisterEffect(e1)
	--To Hand
	local e2=Effect.CreateEffect(c)
	e2:SetProperty(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCondition(c43811008.thcon)
	e2:SetTarget(c43811008.thtg)
	e2:SetOperation(c43811008.thop)
	c:RegisterEffect(e2)
end
function c43811008.costfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x90e) and c:IsAbleToDeckAsCost()
end
function c43811008.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c43811008.costfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c43811008.costfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil)
	Duel.SendtoDeck(g,nil,1,REASON_COST)
	e:SetLabelObject(g:GetFirst())
end
function c43811008.filter1(c,e)
	return c:IsFaceup() and c:IsCanBeFusionMaterial() and c:IsAbleToDeck() and not c:IsImmuneToEffect(e)
end
function c43811008.filter2(c,e,tp,m)
	return c:IsType(TYPE_FUSION) and c:IsSetCard(0x90e) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false)
		and c:CheckFusionMaterial(m)
end
function c43811008.cfilter(c,e,tp)
	return c:IsSetCard(0x90e) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c43811008.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c43811008.cfilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,e:GetLabelObject(),e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c43811008.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local cg=Duel.SelectMatchingCard(tp,c43811008.cfilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,e:GetLabelObject(),e,tp)
	if cg:GetCount()==1 then 
		Duel.SpecialSummon(cg,0,tp,tp,false,false,POS_FACEUP)
		local mg=Duel.GetMatchingGroup(c43811008.filter1,tp,LOCATION_GRAVE,0,nil,e)
		if Duel.IsExistingMatchingCard(c43811008.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg)
			and Duel.SelectYesNo(tp,aux.Stringid(43811008,0)) then
			local sg=Duel.GetMatchingGroup(c43811008.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg)
			if sg:GetCount()==0 then return end
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local tg=sg:Select(tp,1,1,nil)
			local tc=tg:GetFirst()
			local mat=Duel.SelectFusionMaterial(tp,tc,mg)
			tc:SetMaterial(mat)
			Duel.SendtoDeck(mat,nil,2,REASON_RETURN+REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
			Duel.BreakEffect()
			Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
			tc:CompleteProcedure()
		end
	end
end
function c43811008.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return bit.band(r,0x40)==0x40 and rp~=tp and c:GetPreviousControler()==tp
end
function c43811008.thfilter(c)
	return c:IsSetCard(0x90e) and c:IsAbleToHand()
end
function c43811008.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c43811008.thfilter,tp,LOCATION_DECK,0,1,nil) 
		and Duel.IsExistingMatchingCard(c43811008.tgfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,0)
end
function c43811008.tgfilter(c)
	return c:IsSetCard(0x90e) and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end
function c43811008.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOHAND)
	local hg=Duel.SelectMatchingCard(tp,c43811008.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if hg:GetCount()>0 and Duel.SendtoHand(hg,nil,REASON_EFFECT)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local gg=Duel.SelectMatchingCard(tp,c43811008.tgfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil)
		if gg:GetCount()>0 then
			Duel.SendtoGrave(gg,REASON_EFFECT)
		end
	end
end
